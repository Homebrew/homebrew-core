class Riak < Formula
  desc "Distributed database"
  homepage "http://basho.com/products/riak-kv/"
  url "https://files-source.tiot.jp/riak/kv/2.2/2.2.3/osx/10.8/riak-2.2.3-OSX-x86_64.tar.gz"
  version "2.2.3"
  sha256 "6c213a745e2e61ed2eea5500184d5514548b90c0b14bbb6b3d0387f52d593b9e"

  bottle :unneeded

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
