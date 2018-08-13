class Sqoop < Formula
  desc "Transfer bulk data between Hadoop and structured datastores"
  homepage "https://sqoop.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=sqoop/1.4.7/sqoop-1.4.7.tar.gz"
  version "1.4.7"
  sha256 "0278dc4e0cd6f3797d8c9cb7c205994f5aaed050b86afe59fb0e9328739231c7"
  revision 1

  bottle :unneeded

  depends_on :java => "1.6+"
  depends_on "hadoop"
  depends_on "hbase"
  depends_on "hive"
  depends_on "zookeeper"
  depends_on "coreutils"

  def sqoop_envs
    <<~EOS
      export HADOOP_HOME="#{Formula["hadoop"].opt_prefix}"
      export HBASE_HOME="#{HOMEBREW_PREFIX}"
      export HIVE_HOME="#{HOMEBREW_PREFIX}"
      export HCAT_HOME="#{HOMEBREW_PREFIX}"
      export ZOOCFGDIR="#{etc}/zookeeper"
      export ZOOKEEPER_HOME="#{Formula["zookeeper"].opt_prefix}"
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

  def caveats; <<~EOS
    Hadoop, Hive, HBase and ZooKeeper must be installed and configured
    for Sqoop to work.
  EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/sqoop version")
  end
end
