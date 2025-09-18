class Ttygif < Formula
  desc "Converts a ttyrec file into gif files"
  homepage "https://github.com/icholy/ttygif"
  url "https://github.com/icholy/ttygif/archive/refs/tags/1.6.0.tar.gz"
  sha256 "050b9e86f98fb790a2925cea6148f82f95808d707735b2650f3856cb6f53e0ae"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d5fce5ba582f5b18009dc239f63010c981ebf1181a5f34072d6550f73f2e8053"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b6e237ea0e9b4a23fd56ec73b8946859eebcc2b4fb732c6268a9ce942db6ad8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "440b8d0af646eb7601a60d54d5af8813aa268593ebc3edd5dd1961f19915aee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d782d59a6f04174b4d94642784cd3a3d3d3f9005c13f8e22a53d6c0473ebf4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c953e6967a6bc0c649d81c226565818a223a509fc11e556c7bd242b347c888f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59d6b52ffd6c8f0680e6dda60fdf17dd1f445abb1339be73687dac519b847517"
    sha256 cellar: :any_skip_relocation, sonoma:         "660c1ff6f6e028646a79a81f535084202bcea231e9d574c74b6e3b01e8ba3373"
    sha256 cellar: :any_skip_relocation, ventura:        "3a0f3584b025375422648b2f6c7f5b59b1623253e61a5400f84e6974c62111d4"
    sha256 cellar: :any_skip_relocation, monterey:       "4c955eb6cda1e45e9668ad7eb8cd2f4c8d03754a4fb877a08fc4ffeb6c8602cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd4346a5d4ff4e7fdbb5fefad4ab5943f927e43d7fb4fe5a45a496d6f8bf62f3"
    sha256 cellar: :any_skip_relocation, catalina:       "c9fcc9f4e6331acefe39cd12ed8c8ae353d028040526c84f98d6f656cd34af03"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6f640f1292cd1506f8c97f9f177cb9dbeffa113ca28c36c65da9609c1770551b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db4dfad8975d11c05ab0ffad2da2ca5864872948ba4e872323e9dee07c26289"
  end

  depends_on "imagemagick"
  depends_on "ttyrec"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Disable test on Linux because it fails with this error:
    # Error: WINDOWID environment variable was empty.
    # This is expected as a valid X window ID is required:
    # https://walialu.com/ttygif-error-windowid-environment-variable-was-empty
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["TERM_PROGRAM"] = "Something"
    system bin/"ttygif", "--version"
  end
end
