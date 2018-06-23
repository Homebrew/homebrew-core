class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/2.9.4.tar.gz"
  sha256 "ad066b48565e82208d5e0451891366f6a9b9a3648d149d14c83d00f4712094d3"
  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    sha256 "4ec2e3b27d79d68cd52fa7ea222ec1d44f45f11b4a756e6f78fd578cd2bde542" => :high_sierra
    sha256 "19ae05c1e0ab1f90ed41fbcb320d96a41fa43012f39ab4ac7e714148c802119a" => :sierra
    sha256 "41b2171f3609acf4e10770809b79dbd11c7ee6a1c2f384b0d8ef04767f7d5e93" => :el_capitan
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
