class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.100.tar.gz"
  sha256 "adb6c010280178dafa64d3baaa0f58fee84b74ffafe4a8a0cc787f2200beaeee"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf16792a98ba7fbd512bcc86c54a824e76ebc499a4b571093944819be9427869"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd45e88a81a7cbad45b9cd9ab5611d45c02848f38370d261cb2c9dcd39a92a51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "383a4839e6894f916da8f15311eedc69b142bacaa842d7d508ffc4f7c940c6b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f420ec1d98a5d730d5eb3987087d321ae617ec90edb7b74fdcbd5b92a70e287b"
    sha256 cellar: :any,                 x86_64_linux:      "a033f5d75e12edf5c7a14d5e742d93b4d1a4889e717aaccb5491d4c4c4522369"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end
