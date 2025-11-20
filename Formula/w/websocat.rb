class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "919ee83c961074c176a129874a77c02889401f3548c2536a84c4427f97cfeb26"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a364bf89f3b9a3db00b322e8649792ee1d00af374dbb7f48f630acabefbd75a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43528315c386262e6d11036b016fc7ddab24c362e1a38e036b31133c3bf194af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e1c06621d0e8448803752f47c35f13a56a16e118de637aa6c19c20f1c954abe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eeecfce3377a6c4093b50d964f083b4b03dc39f13b933e2b57a38eed3d957066"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a9d377c6bfa1776e72631b6a2599a1b45f409d2307b2c3dd36db86dfb8a778"
    sha256 cellar: :any_skip_relocation, ventura:       "60b160dbc0fcb8ac2ffd81f9b27cc912ce15ba52b091897fe5d7ff0ff2e2cdd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bed9942cd5ce9dc488d0e14ff99e38874568aba619f37a6f6c70b6aed1b34b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47743949aee1665357d781c961840c97f3d781650995f7b0c9cb541f898c756f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  # bump traitobject to build against rust 1.87
  patch do
    url "https://github.com/vi/websocat/commit/d4455623e777231d69b029d69d7a17c0de2bafe7.patch?full_index=1"
    sha256 "505f8fa7311ef11c60f9e665aa1479fbdf4b666e9eae01db56567a3f25866c05"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system bin/"websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
