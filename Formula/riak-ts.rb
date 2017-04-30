class RiakTs < Formula
  desc "NoSQL time series database optimized for IoT and Time Series data."
  homepage "http://basho.com/products/riak-ts/"
  url "http://s3.amazonaws.com/downloads.basho.com/riak_ts/1.3/1.3.0/osx/10.8/riak-ts-1.3.0-OSX-x86_64.tar.gz"
  version "1.3.0"
  sha256 "f83c06b2b041562a88e4325c5c132ab274abab6a9f569ed679e4fa400660010c"

  bottle :unneeded

  depends_on :macos => :mountain_lion
  depends_on :arch => :x86_64

  def install
    logdir = var + "log/riak-ts"
    datadir = var + "lib/riak-ts"
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
    bin.write_exec_script libexec/"bin/riak-shell"
    bin.write_exec_script libexec/"bin/search-cmd"
  end

  test do
  end
end
