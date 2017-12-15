class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/2.9.3.tar.gz"
  sha256 "1bacc03857cca5a2fdcda060886bf51dbf73b129abbb7251b8eb95bc874e5376"
  revision 2

  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    sha256 "668b13f2a60e4882aa17479309551a934fae6f71178b05b1293b3ab7fe0cfb5f" => :high_sierra
    sha256 "6dd163f2679959fc2ee5e340d61ab0e500efb350e395a26063d535ae09b18592" => :sierra
    sha256 "54522adbec639a9a4e743730b39e97199f45b2f21d4a23533e7f3cd5afb0d6ae" => :el_capitan
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
