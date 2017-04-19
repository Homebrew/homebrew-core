class Streamsets < Formula
  desc "ETL tool with a graphical IDE for building dataflow pipelines"
  homepage "https://streamsets.com/"
  url "https://archives.streamsets.com/datacollector/1.5.1.0/tarball/streamsets-datacollector-all-1.5.1.0.tgz"
  sha256 "d848ffaec4cbadce0e7aa031fb30d1e7e13c84be9115ecd6c69643ff02400fc8"

  bottle :unneeded

  depends_on :java => "1.7+"
  depends_on "md5sha1sum"

  def install
    # rename old SDC_CONF if it exists
    if File.exist?("#{var}/lib/sdc")
      mv "#{etc}/sdc", "#{etc}/sdc-old", :force => true
    else
      (var/"log/sdc").mkpath
      (var/"lib/sdc-resources").mkpath
      (var/"lib/sdc").mkpath
      (etc/"sdc").mkpath
    end

    libexec.install Dir["*"]

    ENV["STREAMSETS_HOME"] = libexec

    bin.install libexec/"bin/streamsets" => "streamsets"
    bin.env_script_all_files libexec/"bin/", :STREAMSETS_HOME => libexec

    # edit sdc-env.sh so that data is stored in ${HOMEBREW_PREFIX}/var and ${HOMEBREW_PREFIX}/etc, so that data will be saved after brew upgrade
    inreplace "#{libexec}/libexec/sdc-env.sh" do |s|
      s.gsub! "#export SDC_LOG=/var/log/sdc", "export SDC_LOG=#{var}/log/sdc"
      s.gsub! "#export SDC_DATA=/var/lib/sdc", "export SDC_DATA=#{var}/lib/sdc"
      s.gsub! "#export SDC_RESOURCES=/var/lib/sdc-resources", "export SDC_RESOURCES=#{var}/lib/sdc-resources"
      s.gsub! "#export SDC_CONF=/etc/sdc", "export SDC_CONF=#{etc}/sdc"
    end
    (etc/"sdc").install Dir["#{libexec}/etc/*"]
  end

  def caveats; <<-EOS.undent
    Old configuration files have been moved to #{etc}/sdc-old. The new
      configuration files should be updated as described in the documentation.
      See https://streamsets.com/documentation/datacollector/latest/help/#Upgrade/FullBasicTarball.html#task_wzl_hst_xv
    EOS
  end

  test do
    system bin/"streamsets", "stagelibs", "-list"
  end
end
