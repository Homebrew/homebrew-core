class SpdxSbomGenerator < Formula
  desc "Support CI generation of SBOMs via golang tooling"
  homepage "https://github.com/opensbom-generator/spdx-sbom-generator"
  url "https://github.com/opensbom-generator/spdx-sbom-generator/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "3811d652de0f27d3bfa7c025aa6815805ef347a35b46f9e2a5093cc6b26f7b08"
  license any_of: ["Apache-2.0", "CC-BY-4.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3d5f579302dcda06b94f698a0cab5ecf485d399b4e9da91a33433a992c2684c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ca95017f73479fc8907cb24a392bab8d15c69789c565d0f2129502e00d520742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "489910223a1ba3e54e06461065428738c88018a25f2d82f7fe4e87bb8e8eb552"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1905f9d0dd236c453fe5579857110071680d4241ad4eedb1150bcd5163208fdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f26e3e6fef82389087371f38b3a90081f74a6ad7f0d8dfc2d25f5908600ba9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f56b5a0cc9581b2f7347a23264cd70dcb76e1fa170ababf583fa1d4fad6b36e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fe1dd10d9e54db236333d077866b2ccf958d28b70d6961df38d51e900e517bf"
    sha256 cellar: :any_skip_relocation, ventura:        "4090620fb4c0f354d773f76323a89052c356d46fd45f311204cc6c3e15644036"
    sha256 cellar: :any_skip_relocation, monterey:       "af8c523abaa929f3616245751392b6fe9ba998e0f88e798e831d66def859fd88"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f116d9eb974cd064162a5c55c0143b8b2bf2cb2534b76a27eaedfcef6031da6"
    sha256 cellar: :any_skip_relocation, catalina:       "f733c9630d8ad36f7ded3b2f9a10267251052625fb63e21fb3acc00f7863f919"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d00ff724f5f72911dd7c49600f95a556d18c4654588d6ae4a0a79278431ce29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd798a009fd918ecc7ebc002b181fc87aa382722f07d6ffdc5b2ab0481ea3951"
  end

  deprecate! date: "2025-02-13", because: :repo_archived

  depends_on "go" => [:build, :test]

  def install
    target = if OS.linux?
      inreplace "Makefile", "GOARCH=amd64", "GOARCH=arm64" if Hardware::CPU.arm?
      "build"
    elsif Hardware::CPU.arm?
      "build-mac-arm64"
    else
      "build-mac"
    end

    system "make", target

    prefix.install "bin"
  end

  test do
    system "go", "mod", "init", "example.com/tester"

    assert_equal "panic: runtime error: index out of range [0] with length 0",
                 shell_output("#{bin}/spdx-sbom-generator 2>&1", 2).split("\n")[4]
  end
end
