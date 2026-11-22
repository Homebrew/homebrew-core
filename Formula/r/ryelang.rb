class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.83.tar.gz"
  sha256 "a3eecabd60651245dc2a5ceb7f58ec71e2b05e7c00c0ae44aeb658dd568db13a"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "355d782511b95213ffcdc15709f9a1b4fce5bcdf35e2dec0463a3d1adfab5450"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "24a00a43e95366cc415ebc587fa2d13a22d0bd251debd5b1177ee2d60eb3432a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aed5925f35d83d020ed4050b31a5354592f3c0e8accbc2369a8d2e1b2681490a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dddecfc7a4674efd6007be5de94aed27be0e0e8013f49b8f3e1abb7f35e56d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "145edd58d695293ad8e9c4e232bbf9cf5934de8fb93bc5f61b9e5d4f97c657f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "96dfd8b8bd0b087e7ec7b23f423f0a1f8a5653cc4c4a4e704af43ba9a2aa0cda"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[-X github.com/refaktor/rye/runner.Version=#{version}]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~RYE
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    RYE
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end
