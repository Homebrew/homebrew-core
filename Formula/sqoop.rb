class Sqoop < Formula
  desc "Transfer bulk data between Hadoop and structured datastores"
  homepage "https://sqoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz"
  mirror "https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz"
  version "1.4.7"
  sha256 "64111b136dbadcb873ce17e09201f723d4aea81e5e7c843e400eb817bb26f235"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04de1ca8398879433620c8bb66cda1c959fb3b724e6ed7638fd7e26d6e132483"
  end

  # See https://attic.apache.org/projects/sqoop.html
  deprecate! date: "2021-06-16", because: :deprecated_upstream

  depends_on "coreutils"
  depends_on "hadoop"
  depends_on "hbase"
  depends_on "hive"
  depends_on "openjdk"
  depends_on "zookeeper"

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
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)

    # Install a sqoop-env.sh file
    envs = libexec/"conf/sqoop-env.sh"
    envs.write(sqoop_envs) unless envs.exist?
  end

  def caveats
    <<~EOS
      Hadoop, Hive, HBase and ZooKeeper must be installed and configured
      for Sqoop to work.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqoop version")
  end
end
