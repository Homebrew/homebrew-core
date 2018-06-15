class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/2.9.4.tar.gz"
  sha256 "ad066b48565e82208d5e0451891366f6a9b9a3648d149d14c83d00f4712094d3"
  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    sha256 "ea51c46528b302bc1b59fd81788a0d5d65b7c348aebd8f10af2df8c620678a8d" => :high_sierra
    sha256 "f1a32f7ad9b41c5f395f7e04ae2afff8cdf5d2a4ded2cc61bdf4dd8db1242992" => :sierra
    sha256 "adbc31b9065ad979247623476b4d0fe22db78e85f6237b9f1a4d22f61880462d" => :el_capitan
  end

  depends_on "ruby"

  def install
    inreplace "lib/common/common_helper.rb" do |s|
      s.gsub! "File.join(USER_DIR, '.wpscan/cache')", "'#{var}/cache/wpscan'"
      s.gsub! "File.join(USER_DIR, '.wpscan/data')", "'#{var}/wpscan/data'"
      s.gsub! "File.join(USER_DIR, '.wpscan/log.txt')", "'#{var}/log/wpscan/log.txt'"
    end

    system "unzip", "-o", "data.zip"
    libexec.install "data", "lib", "spec", "Gemfile", "Gemfile.lock", "wpscan.rb"

    ENV["GEM_HOME"] = libexec
    ENV["BUNDLE_PATH"] = libexec
    ENV["BUNDLE_GEMFILE"] = libexec/"Gemfile"
    system "gem", "install", "bundler"
    bundle = Dir["#{libexec}/**/bundle"].last
    system bundle, "install", "--without", "test"

    (bin/"wpscan").write <<~EOS
      #!/bin/bash
      GEM_HOME=#{libexec} BUNDLE_GEMFILE=#{libexec}/Gemfile \
        exec #{bundle} exec ruby #{libexec}/wpscan.rb "$@"
    EOS
  end

  def post_install
    (var/"log/wpscan").mkpath
    # Update database
    system bin/"wpscan", "--update"
  end

  def caveats; <<~EOS
    Logs are saved to #{var}/cache/wpscan/log.txt by default.
  EOS
  end

  test do
    assert_match "URL: https://wordpress.org/",
                 pipe_output("#{bin}/wpscan --url https://wordpress.org/")
  end
end
