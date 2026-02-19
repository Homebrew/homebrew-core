class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://tetragon.io/"
  url "https://github.com/cilium/tetragon/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "83469d661ca86ce74e75c10eb01628291088cedb73e2641029504b3bd7fb1f86"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0111161e8793db09cd938510cca6dada677985f41a7ba2b6aa9c8f55b7daf7c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ffac422ba4d5219d062e6f81d67607e74c20d8e12e3cc32c33da2429c1f89f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0adf70e96f251d395b1cd432012de0d6ce59fd775103c61f775ca0126b5ca516"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1c926f99a77c8cd14552ccf57788c3453753101cf8ad1b3d853b8dcf44f2b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2938872c80920878fb745c56ae96bed320150c878aca248f1e0ce5f47ff2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78633dd890f3b3552edb26ae9822200ac52febaf56a5c23c02423eca6577c895"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", shell_parameter_format: :cobra)
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end
