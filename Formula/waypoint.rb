class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.11.2.tar.gz"
  sha256 "45d38bf222ed7d3b1e5eba4499e2513b6d04e4b26cb77acd1272f4258e1a9822"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14c2dcddba43df4295c626ad709e5b6de24dc5b6ea90523b75f6129bd4dde84b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25094deb76ef254ae10c092d96fae4f8a3a86a1aa2497082a05d9cecae4e2051"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c5fb972d0b988b2bfa0ca3a496ce4241d3d93971c2b4a912a7ca0ccada6d975"
    sha256 cellar: :any_skip_relocation, ventura:        "252e6ca4c272088507ebe8a74de249514a7941af4b59f2df995c6e2f1e85b2be"
    sha256 cellar: :any_skip_relocation, monterey:       "c899199d5a7c1220ea793d1e9b50ce6ad5735bd4875fd8f50b0ff6b11ccb3b3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "30fb65f8ef33bb2d303e235e084c149efcf2e5a775e7378419fc4761c0ce153e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea3d5e916168a4be9341a2c098cd00d75997b5fe746d5e41e4d2ae542bf272ea"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    output = shell_output("#{bin}/waypoint context list")
    assert_match "No contexts. Create one with `waypoint context create`.", output

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
