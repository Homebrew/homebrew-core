class Riak < Formula
  desc "Distributed database"
  homepage "http://basho.com/products/riak-kv/"
  url "https://s3.amazonaws.com/downloads.basho.com/riak/2.2/2.2.0/osx/10.8/riak-2.2.0-OSX-x86_64.tar.gz"
  version "2.2.0"
  sha256 "51ea63d6efaa3bba4efb0ca13de81da2e2662b6691b4132cf552ca7635c8a857"

  bottle :unneeded

  # Broken dylib links (should be fixed in 2.2.1)
  # https://github.com/basho/eleveldb/issues/236

  # Currently refuses to use non-system OpenSSL
  # https://github.com/basho/riak/issues/888
  # depends_on "openssl"

  depends_on :macos => :mountain_lion
  depends_on :arch => :x86_64

  def install
    logdir = var + "log/riak"
    datadir = var + "lib/riak"
    libexec.install Dir["*"]
    logdir.mkpath
    datadir.mkpath
    (datadir + "ring").mkpath
    inreplace "#{libexec}/lib/env.sh" do |s|
      s.change_make_var! "RUNNER_BASE_DIR", libexec
      s.change_make_var! "RUNNER_LOG_DIR", logdir
    end
    inreplace "#{libexec}/etc/riak.conf" do |c|
      c.gsub! /(platform_data_dir *=).*$/, "\\1 #{datadir}"
      c.gsub! /(platform_log_dir *=).*$/, "\\1 #{logdir}"
    end
    bin.write_exec_script libexec/"bin/riak"
    bin.write_exec_script libexec/"bin/riak-admin"
    bin.write_exec_script libexec/"bin/riak-debug"
    bin.write_exec_script libexec/"bin/search-cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/riak version")
  end
end
