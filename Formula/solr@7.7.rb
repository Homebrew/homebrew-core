class SolrAT77 < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://lucene.apache.org/solr/"
  url "https://www.apache.org/dyn/closer.lua?path=lucene/solr/7.7.2/solr-7.7.2.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/7.7.2/solr-7.7.2.tgz"
  sha256 "eb8ee4038f25364328355de3338e46961093e39166c9bcc28b5915ae491320df"
  revision 1

  bottle :unneeded

  keg_only :versioned_formula

  depends_on "openjdk"

  skip_clean "example/logs"

  def install
    # Fix the classpath for the post tool
    inreplace "bin/post", '"$SOLR_TIP/dist"', "#{libexec}/dist"

    bin.install %w[bin/solr bin/post bin/oom_solr.sh]
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => Formula["openjdk"].opt_prefix
    pkgshare.install "bin/solr.in.sh"
    prefix.install %w[example server]
    libexec.install Dir["*"]

    # Fix the paths in the sample solrconfig.xml files
    Dir.glob(["#{prefix}/example/**/solrconfig.xml",
              "#{prefix}/**/data_driven_schema_configs/**/solrconfig.xml",
              "#{prefix}/**/sample_techproducts_configs/**/solrconfig.xml"]) do |f|
      inreplace f, ":../../../..}/", "}/libexec/"
    end
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/solr@7.7/bin/solr start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/solr</string>
            <string>start</string>
            <string>-f</string>
          </array>
          <key>ServiceDescription</key>
          <string>#{name}</string>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"solr"
  end
end
