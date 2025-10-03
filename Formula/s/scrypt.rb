class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.3.3.tgz"
  sha256 "1c2710517e998eaac2e97db11f092e37139e69886b21a1b2661f64e130215ae9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec74c8180728b4cf18c563e9e517833fe690d44d06fdd0b00440dcd9c911d5c6"
    sha256 cellar: :any,                 arm64_sequoia: "086c6480fd2730ac530d61e01beafeb057e0ba787ecd7461015d2eebe2faf127"
    sha256 cellar: :any,                 arm64_sonoma:  "d3c54c7d270128101ecce159c9d199637da3e5d84b282c92e0a6cbc65d3962a1"
    sha256 cellar: :any,                 arm64_ventura: "ca2d00727c2c9341fc476d525d5317cc04fdf8972ca73500b2b39d0e388306f7"
    sha256 cellar: :any,                 sonoma:        "a229f4170e58803a154fc60d7354497f0cb8ccb21f65b00cc1945ed81a9e7e6e"
    sha256 cellar: :any,                 ventura:       "cdd6ae43fbebe770617c06ad1a1ecdde3672f7d206503b169b073da5fd646987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94cc29fdc84753347d35adcc2f4a58618979fcb4c6132caf3a9a0600738223d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7ea3f7f130c909269e84c6a6d70697f38589de63f248e6ffbb8d118dfac00d1"
  end

  head do
    url "https://github.com/Tarsnap/scrypt.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"

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
