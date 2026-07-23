class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.3.3.tgz"
  sha256 "1c2710517e998eaac2e97db11f092e37139e69886b21a1b2661f64e130215ae9"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "26cdc2a8154fdc20524a0e52a2da50b65be10ba0c6c98499b9a5d1742a9d4e84"
    sha256 cellar: :any,                 arm64_sequoia: "630bc5c3e348ee1c810b3546504bbff8329e58983f792cf2d007c6f0657b0502"
    sha256 cellar: :any,                 arm64_sonoma:  "9a2e326dc8834e2787b64d7c85a1626a79edf3a17256599dad8b67f65f52e005"
    sha256 cellar: :any,                 sonoma:        "0943257b49f22c6453af42c6590f61ec221b3012f807f3e65df27fa750bb4acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5bcfd83b572ce88d68ad551bc7d3f8d32ee83f808f91f6bf0d3beb629013a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa1813d48ea5823d35f9252631e272831a24b9355b92d75b9e0b50030a025fd6"
  end

  head do
    url "https://github.com/Tarsnap/scrypt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@4"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    require "expect"
    require "pty"

    touch "homebrew.txt"
    PTY.spawn(bin/"scrypt", "enc", "homebrew.txt", "homebrew.txt.enc") do |r, w, _pid|
      r.expect "Please enter passphrase: "
      w.write "Testing\n"
      r.expect "Please confirm passphrase: "
      w.write "Testing\n"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_path_exists testpath/"homebrew.txt.enc"
  end
end
