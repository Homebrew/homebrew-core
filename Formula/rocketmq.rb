class Rocketmq < Formula
  desc "Distributed messaging and streaming platform"
  homepage "https://rocketmq.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=rocketmq/4.9.0/rocketmq-all-4.9.0-bin-release.zip"
  mirror "https://archive.apache.org/dist/rocketmq/4.9.0/rocketmq-all-4.9.0-bin-release.zip"
  sha256 "d13416f9e80f5d4414300fbf84518a22476e7e298d19c6b8d21c7e99c4599065"
  license "Apache-2.0"

  depends_on "openjdk"

  resource "netty-all" do
    url "https://search.maven.org/remotecontent?filepath=io/netty/netty-all/4.1.65.Final/netty-all-4.1.65.Final.jar"
    sha256 "e6cdae2b23e410b35128dac651b954aedd583bc10959a1e702c7dba7ac850d0e"
  end

  def install
    inreplace "bin/runserver.sh" do |s|
      s.gsub! "export CLASSPATH=.:${BASE_DIR}/conf:${CLASSPATH}",
        "export CLASSPATH=.:${BASE_DIR}/lib/*:${BASE_DIR}/conf:${CLASSPATH}"
      s.gsub! "JAVA_OPT=\"${JAVA_OPT} -Djava.ext.dirs", "#JAVA_OPT=\"${JAVA_OPT} -Djava.ext.dirs"
      s.gsub! "choose_gc_log_directory\n", ""
      s.gsub! "choose_gc_options\n", "\n"
    end

    inreplace "bin/runbroker.sh" do |s|
      s.gsub! "export CLASSPATH=.:${BASE_DIR}/conf:${CLASSPATH}",
        "export CLASSPATH=.:${BASE_DIR}/lib/*:${BASE_DIR}/conf:${CLASSPATH}"
      s.gsub! "JAVA_OPT=\"${JAVA_OPT} -Djava.ext.dirs", "#JAVA_OPT=\"${JAVA_OPT} -Djava.ext.dirs"
      s.gsub! "JAVA_OPT=\"${JAVA_OPT} -verbose:gc -Xloggc:${GC_LOG_DIR}/rmq_broker_gc_%p_%t.log -XX:+PrintGCDetails" \
        " -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -XX:+PrintAdaptiveSizePolicy\"", ""
      s.gsub! "JAVA_OPT=\"${JAVA_OPT} -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=30m\"", ""
      s.gsub! "JAVA_OPT=\"${JAVA_OPT} -XX:-UseLargePages -XX:-UseBiasedLocking\"",
        "JAVA_OPT=\"${JAVA_OPT} -XX:-UseLargePages\""
      s.gsub! "choose_gc_log_directory\n", "\n"
    end

    inreplace "bin/tools.sh" do |s|
      s.gsub! "export CLASSPATH=.:${BASE_DIR}/conf:${CLASSPATH}",
        "export CLASSPATH=.:${BASE_DIR}/lib/*:${BASE_DIR}/conf:${CLASSPATH}"
      s.gsub! "JAVA_OPT=\"${JAVA_OPT} -Djava.ext.dirs", "#JAVA_OPT=\"${JAVA_OPT} -Djava.ext.dirs"
    end

    # netty-all-4.0.42.Final.jar doesn't work on arm64 macOS
    rm_rf "lib/netty-all-4.0.42.Final.jar"
    libexec.install "lib"

    # install netty-all-4.1.65.Final.jar which works on arm64 macOS
    resource("netty-all").stage { cp "netty-all-4.1.65.Final.jar", libexec/"lib" }

    # remove non-executable
    rm_rf "bin/dledger"
    # remove Windows scripts
    rm_r Dir.glob("bin/*.cmd")

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)

    inreplace "conf/logback_namesrv.xml" do |s|
      s.gsub! %r{\$\{user\.home\}/logs/rocketmqlogs}, "#{var}/log/rocketmq"
    end

    inreplace "conf/logback_broker.xml" do |s|
      s.gsub! %r{\$\{user\.home\}/logs/rocketmqlogs}, "#{var}/log/rocketmq"
    end

    mv "conf", "rocketmq"
    etc.install "rocketmq"
    libexec.install_symlink(etc/"rocketmq" => "conf")

    rm etc/"rocketmq/broker.conf"
    (etc/"rocketmq/broker.conf").write broker_conf
  end

  def post_install
    (var/"rocketmq").mkpath
    (var/"log/rocketmq").mkpath
    (var/"rocketmq/commitlog").mkpath
  end

  def broker_conf
    <<~EOS
      brokerClusterName = DefaultCluster
      brokerName = broker-a
      brokerId = 0
      deleteWhen = 04
      fileReservedTime = 48
      brokerRole = ASYNC_MASTER
      flushDiskType = ASYNC_FLUSH
      storePathRootDir=#{var}/rocketmq
      storePathCommitLog=#{var}/rocketmq/commitlog
      autoCreateTopicEnable=true
    EOS
  end

  def caveats
    <<~EOS
      Data:    #{var}/rocketmq/commitlog
      Logs:    #{var}/log/rocketmq
      Config:  #{etc}/rocketmq/broker.conf

      Start Apache RocketMQ server with two steps:
      1. mqnamesrv
      2. mqbroker -n localhost:9876
    EOS
  end

  test do
    (testpath/"rocketmq").mkpath

    begin
      fork do
        exec "#{bin}/mqnamesrv " \
          "> #{testpath}/test.mqnamesrv.log 2>&1"
      end

      sleep 10

      fork do
        exec "#{bin}/mqbroker -n localhost:9876 "\
          "> #{testpath}/test.mqbroker.log 2>&1"
      end

      sleep 10

      output = shell_output "#{bin}/mqadmin topicList -n localhost:9876"
      assert_match "DefaultCluster", output
    ensure
      system "#{bin}/mqshutdown", "broker"
      system "#{bin}/mqshutdown", "namesrv"
      sleep 10
    end
  end
end
