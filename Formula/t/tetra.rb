class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://github.com/cilium/tetragon"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "7a1ba1e1e15182e3df7198111c2329a1543a8090883ec26dc0f99512d779ef87"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ea854107aa8bb5a843eb9d99013c00983211353b3474ca7276853a65b81f690"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0248a0d631626a8a22d575a1f7fc9d0b38ff9b75ad9e917ab4de63978f027f0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a18922f9ae0e57dbf5e7c17c66623dfefcf343c54bb8bcec39d79126b4c584e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1c50cbcc271dc1008ab77872225af7aad80c7ab0531b36c1819453264df1044"
    sha256 cellar: :any_skip_relocation, ventura:        "80e72434aba445667ff1850c7866dc2a3fd7a98a3fdbbfeca891fc7870acb08b"
    sha256 cellar: :any_skip_relocation, monterey:       "0d724ec4ddbef120c383df4a433f8e1541f72a1e4dee77bb60d47d943c9e5865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfec9cb7a6caf12c0d8dd4566f8a1d23df984a279b48f490890028f2f0135344"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
