class Senpai < Formula
  desc "Modern terminal IRC client"
  homepage "https://sr.ht/~delthas/senpai/"
  url "https://git.sr.ht/~delthas/senpai/archive/v0.4.1.tar.gz"
  sha256 "ab786b7b3cffce69d080c3b58061e14792d9065ba8831f745838c850acfeab24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3babf5b4950b6fe98db4af1331a97661168b54b4d1c9a6648b8ef0da5bafbf90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e62cb0dbef74b43914cfe94dc91d975c97ed53d9042d9be3fc422ef4a37dcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cbb49d7aa9a8343dead0ad9638e7fc738a723b5ce652d041b52364a3cba7f7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6828b6aa784aebd607c3d536d946f764385a0b80d67edfff5978e6026ca56c99"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fdd32340fc297f5d1eef67bfd938089a2c0d07ce57d49bde8d7447adff97c32"
    sha256 cellar: :any_skip_relocation, ventura:       "817074dd4e63738680fb92c3746221928a4c95312d4c70b8c42e5d97ff16d123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f9b02ed34a5b67f8641080d8df39172a50382982dd08f8663f9c7ce8678d469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e40211b47b193298d47b6aed526b5ac662f6e5ff3fe39dc71c7e6f7dbf187c8"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"

    stdout, _stdin, _pid = PTY.spawn bin/"senpai"
    _ = stdout.readline
    assert_equal "Configuration assistant: senpai will create a configuration file for you.\r\n", stdout.readline
  end
end
