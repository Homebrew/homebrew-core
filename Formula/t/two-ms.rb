class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "38141bdadbdbb99745a16c8d77c7acaa9f630a1b423dba34a1b8395327ccff27"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "051f84e7fb50c8e3c50327608ff4eb4c98a398abc5381776ab1b6bd0eb8583fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc9140cc2e3468da6935751aae4306b06fec4d22d9b00c7256799d0c513c4c82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b69396ffa58abcd1a51da226cc3b0e8ad132165dfe729b7901324aea09cc1c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5662f8dd717edf1b72c0f5edc8c15c47a1c2eb7cd02c3c7da871ec630360d81c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c1f02e35841b5237b4fa5ac727ba3952314c9c81078bcd82834d589ed595364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa4c34682dc3befa3f7ace7fdced6fa1834a9a2ca142d04e3d390005d31e2c30"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"2ms"), "main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/2ms --version")

    (testpath/"secret_test.txt").write <<~EOS
      "client_secret" : "6da89121079f83b2eb6acccf8219ea982c3d79bccc3e9c6a85856480661f8fde",
    EOS

    output = shell_output("#{bin}/2ms filesystem --path #{testpath}/secret_test.txt --validate", 2)
    assert_match "Detected a Generic API Key", output
  end
end
