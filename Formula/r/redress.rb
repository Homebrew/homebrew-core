class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.98.tar.gz"
  sha256 "75c2ee3b5083392e605125d00385af3ff2e318c8172689387e48bbda2e1985a1"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b7cf989007bf05e28e90e3afd94db57f45b5cb8e80666281ccdb1ec099eaf6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1120fdcf2de0d26b62812f64bce15aeda48784ae4418278d52f65870854ab526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd3bccabb63383e51a3cd19eb3ab2e6e357cfbeb6d1291e73b865ee5d2168cf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b698d1f9f878298e8bebd90b83dba2919729a70940b3750428c9b5a7721e30eb"
    sha256 cellar: :any,                 x86_64_linux:      "447d9a98cbea1ec6f0226ad17ad239e9c536b1bec0a9a563766a34e6a002caad"
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
