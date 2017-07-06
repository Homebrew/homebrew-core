class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  head "https://github.com/wpscanteam/wpscan.git"

  stable do
    url "https://github.com/wpscanteam/wpscan/archive/2.9.2.tar.gz"
    sha256 "01c888bf2310354823a9522cd929e0caad5570c14eef6f47754c90e268fccad8"

    patch do
      # - Remove xmlrpc/client requirement, already fixed in wpscanteam/wpscan@ec831f7.
      # - Add Gemfile.lock from wpscanteam/wpscan@21f4de2 for reproducibility.
      url "https://gist.githubusercontent.com/anonymous/aa09eed140172009f1eda6268023342c/raw/f69a26776f7768858da08c902ae3d5f75b3e7c36/wpscan-2.9.2-brew.patch"
      sha256 "f8329ba709a0078651532816a8023b285d24652bab299ed7dde8b3e846ca810e"
    end
  end

  bottle do
    sha256 "49178b5a7589c7069af8e3a08cc528ae26b3e929abfbf2fe48a12f3c44778b8a" => :sierra
    sha256 "3988316cd584e6a1b90b95fd490f4a048fb05a583e416c53ef6402829768f597" => :el_capitan
    sha256 "c4ce8ec9c235fc7e1010bf3ba95a94241ded02116429cc21974411454e3b116a" => :yosemite
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
