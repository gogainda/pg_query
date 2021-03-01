require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'open-uri'

LIB_PG_QUERY_TAG = '13-latest-develop'.freeze
LIB_PG_QUERY_SHA256SUM = 'FIXFORRELEASE'.freeze

Rake::ExtensionTask.new 'pg_query' do |ext|
  ext.lib_dir = 'lib/pg_query'
end

RSpec::Core::RakeTask.new
RuboCop::RakeTask.new

task spec: :compile

task default: %i[lint spec]
task test: :spec
task lint: :rubocop

task :clean do
  FileUtils.rm_rf File.join(__dir__, 'tmp/')
  FileUtils.rm_f Dir.glob(File.join(__dir__, 'ext/pg_query/*.o'))
  FileUtils.rm_f File.join(__dir__, 'lib/pg_query/pg_query.bundle')
end

task :update_source do
  workdir = File.join(__dir__, 'tmp')
  libdir = File.join(workdir, 'libpg_query-' + LIB_PG_QUERY_TAG)
  filename = File.join(workdir, 'libpg_query-' + LIB_PG_QUERY_TAG + '.tar.gz')
  testfilesdir = File.join(__dir__, 'spec/files')
  extdir = File.join(__dir__, 'ext/pg_query')
  extbakdir = File.join(workdir, 'extbak')

  unless File.exist?(filename)
    system("mkdir #{workdir}")
    File.open(filename, 'wb') do |target_file|
      URI.open('https://codeload.github.com/lfittl/libpg_query/tar.gz/' + LIB_PG_QUERY_TAG, 'rb') do |read_file|
        target_file.write(read_file.read)
      end
    end

    checksum = Digest::SHA256.hexdigest(File.read(filename))

    #if checksum != LIB_PG_QUERY_SHA256SUM
    #  raise "SHA256 of #{filename} does not match: got #{checksum}, expected #{expected_sha256}"
    #end
  end

  unless Dir.exist?(libdir)
    system("tar -xzf #{filename} -C #{workdir}") || raise('ERROR')
  end

  # Backup important files from ext dir
  system("rm -fr #{extbakdir}")
  system("mkdir #{extbakdir}")
  system("cp -a #{extdir}/pg_query_ruby.{c,sym} #{extdir}/extconf.rb #{extbakdir}")

  FileUtils.rm_rf extdir

  # Reduce everything down to one directory
  system("mkdir #{extdir}")
  system("cp -a #{libdir}/src/* #{extdir}/")
  system("mv #{extdir}/postgres/* #{extdir}/")
  system("rmdir #{extdir}/postgres")
  system("cp -a #{libdir}/pg_query.h #{extdir}/include")
  # Make sure every .c file in the top-level directory is its own translation unit
  system("mv #{extdir}/*{_conds,_defs,_helper}.c #{extdir}/include")
  # Protobuf definitions
  #system("cp -a #{libdir}/protobuf/parse_tree.proto nodes/")
  #system("PATH=$(PWD)/bin:$(PATH) protoc --go_out=. nodes/parse_tree.proto")
  system("protoc --proto_path=#{libdir}/protobuf --ruby_out=#{File.join(__dir__, 'lib/pg_query')} #{libdir}/protobuf/pg_query.proto")
  # Protobuf library code
  system("mkdir -p #{extdir}/include/protobuf")
  system("cp -a #{libdir}/protobuf/*.h #{extdir}/include/protobuf")
  system("mkdir -p #{extdir}/include/protobuf-c")
  system("cp -a #{libdir}/protobuf-c/*.h #{extdir}/include/protobuf-c")
  system("cp -a #{libdir}/protobuf-c/*.h #{extdir}/include")
  system("cp -a #{libdir}/protobuf/*.c #{extdir}/")
  system("cp -a #{libdir}/protobuf-c/*.c #{extdir}/")
  # Other support files
  system("cp -a #{libdir}/testdata/* #{testfilesdir}")
  # Copy back the custom ext files
  system("cp -a #{extbakdir}/pg_query_ruby.{c,sym} #{extbakdir}/extconf.rb #{extdir}")
end
