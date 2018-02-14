class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/2.9.3.tar.gz"
  sha256 "1bacc03857cca5a2fdcda060886bf51dbf73b129abbb7251b8eb95bc874e5376"
  revision 4

  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    sha256 "1f7810c57e5a43dd95396ef3312a8e991576571af1527259461eabc26d1d393e" => :high_sierra
    sha256 "87ab936c1fc7242e1ff8da79ace55a104475a43b39840d28534c91c62f3c3ba5" => :sierra
    sha256 "4934002c28cb8073dbd629f3705a5b5348a88408037e00b7a003174c8773e1b7" => :el_capitan
  end

  depends_on "ruby"

  def install
    inreplace "lib/common/common_helper.rb" do |s|
      s.gsub! "ROOT_DIR, 'cache'", "'#{var}/cache/wpscan'"
      s.gsub! "ROOT_DIR, 'log.txt'", "'#{var}/log/wpscan/log.txt'"
    end

    system "unzip", "-o", "data.zip"
    libexec.install "data", "lib", "spec", "Gemfile", "Gemfile.lock", "wpscan.rb"

    ENV["GEM_HOME"] = libexec
    ENV["BUNDLE_PATH"] = libexec
    ENV["BUNDLE_GEMFILE"] = libexec/"Gemfile"
    system "gem", "install", "bundler"
    system libexec/"bin/bundle", "install", "--without", "test"

    (bin/"wpscan").write <<~EOS
      #!/bin/bash
      GEM_HOME=#{libexec} BUNDLE_GEMFILE=#{libexec}/Gemfile \
        exec #{libexec}/bin/bundle exec ruby #{libexec}/wpscan.rb "$@"
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
