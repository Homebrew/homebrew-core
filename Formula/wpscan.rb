class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/2.9.3.tar.gz"
  sha256 "1bacc03857cca5a2fdcda060886bf51dbf73b129abbb7251b8eb95bc874e5376"
  revision 3

  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    sha256 "0cac9b80c56eee7b13ddb42c929947b9a88e881b0cb31db2b95318d6e54f0d70" => :high_sierra
    sha256 "f2b17ca3d4def90fb64ef294dd5f222fe82a7f6530ba9d2f99e7695b4c4e72b0" => :sierra
    sha256 "1061278d5b4ff08272c91649eede37002a0293e90a1e2f6406bcc5f23b51e98c" => :el_capitan
  end

  depends_on :ruby => "2.1.9"

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
