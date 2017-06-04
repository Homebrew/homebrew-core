class Sqoop < Formula
  desc "Transfer bulk data between Hadoop and structured datastores"
  homepage "https://sqoop.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=sqoop/1.4.6/sqoop-1.4.6.bin__hadoop-2.0.4-alpha.tar.gz"
  version "1.4.6"
  sha256 "d582e7968c24ff040365ec49764531cb76dfa22c38add5f57a16a57e70d5d496"

  bottle :unneeded

  depends_on :java => "1.6+"
  depends_on "hadoop"
  depends_on "hbase"
  depends_on "hive"
  depends_on "zookeeper"
  depends_on "coreutils"

  # Patch for readlink -f missing on macOS. Should be fixed in 1.4.7.
  # https://issues.apache.org/jira/browse/SQOOP-2531
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/77adf73/sqoop/1.4.6.patch"
    sha256 "f13af5c6525f5bf8f3b993c3ece4f21133680fdbebb663fd4b7b6db9039b07b4"
  end

  def sqoop_envs
    <<-EOS.undent
      export HADOOP_HOME="#{HOMEBREW_PREFIX}"
      export HBASE_HOME="#{HOMEBREW_PREFIX}"
      export HIVE_HOME="#{HOMEBREW_PREFIX}"
      export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def install
    libexec.install %w[bin conf lib]
    libexec.install Dir["*.jar"]

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.6+"))

    # Install a sqoop-env.sh file
    envs = libexec/"conf/sqoop-env.sh"
    envs.write(sqoop_envs) unless envs.exist?
  end

  def caveats; <<-EOS.undent
    Hadoop, Hive, HBase and ZooKeeper must be installed and configured
    for Sqoop to work.
    EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/sqoop version")
  end
end
