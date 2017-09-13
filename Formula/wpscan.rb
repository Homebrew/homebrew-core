class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/2.9.3.tar.gz"
  sha256 "1bacc03857cca5a2fdcda060886bf51dbf73b129abbb7251b8eb95bc874e5376"
  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    sha256 "20db28bc388fed0b55b3c832a6554a2daaca7f9fc28ee133bbd317d822f51099" => :sierra
    sha256 "2f4c6fa37a8ebcda6acc281708f9bdfcaaba5a02c8097b445089e09f7814e2d7" => :el_capitan
    sha256 "661e08da7064b2609e4e3a0c7bd2769935f479d4930563e831b5eaa2edbd0b0f" => :yosemite
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

    (bin/"wpscan").write <<-EOS.undent
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

  def caveats; <<-EOS.undent
    Logs are saved to #{var}/cache/wpscan/log.txt by default.
    EOS
  end

  test do
    assert_match "URL: https://wordpress.org/",
                 shell_output("#{bin}/wpscan --url https://wordpress.org/")
  end
end
