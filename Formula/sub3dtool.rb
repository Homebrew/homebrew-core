class Sub3dtool < Formula
  desc "Sub3dtool"
  homepage "https://code.google.com/archive/p/sub3dtool/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/sub3dtool/sub3dtool-0.4.2.tar.gz"
  sha256 "afb8ed7456a0b17035d27865343dbc9687a178e2ecf4362a7c0dd1b00dccf155"
  depends_on "make" => :build

  def install
    system "make"
    bin.install "sub3dtool"
  end

  test do
    system "#{bin}/sub3dtool", "--help"
  end
end
