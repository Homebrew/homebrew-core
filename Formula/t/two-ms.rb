class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v5.2.4.tar.gz"
  sha256 "de1fb907ecf113629233f7e7139d791ad7b91d6c4eae2c523a5c79d4b7fc1825"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7b261e974568daf603b5a53d5ae2a1ffae13e9874f002e2f2e587d941752052"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad96916091d4fdbbee79de81f654faba76c1e8bc878ed95e7150419d3ba460d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30d1a6c6d052262349dbdfd86b55b7b1402ffab7cad9ad4b3794db7097e81e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a8f42db758a4b54215f61d4661cebbb0b39b239cf1ddd91996cedc81ffed37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd5681714e01e3a7266265054982ac57c71b9e6c5260445953dad3728eeb1168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ab46e55dd59bd36e147c7f5a88c2ca1ab0aa3ae84a017b5282d36fb11bec19"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"2ms"), "main.go"
    generate_completions_from_executable(bin/"2ms", shell_parameter_format: :cobra)
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
