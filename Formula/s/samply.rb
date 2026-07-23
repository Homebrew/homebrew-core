class Samply < Formula
  desc "CLI sampling profiler"
  homepage "https://github.com/mstange/samply"
  url "https://github.com/mstange/samply/archive/refs/tags/samply-v0.13.1.tar.gz"
  sha256 "7002789471f8ef3a36f4d4db7be98f2847724e2b81a53c5e23d5cae022fb704b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/mstange/samply.git", branch: "main"

  livecheck do
    url :stable
    regex(/^samply[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c85be94ac3ab2741c5674f88393e4a40cebededb1bded0fa745a7014befb3e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74b84ca23e39806e347daaa2f0643e67dbdd9d9524ffefd5e33d3209e7d657de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8730482276dce18547b0d01db36665ac3520a360007525e4e8e2e4efa04c02bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a64f2cb47e7a97c363081d9a4bd532601bd08683cc32e3d60106396e20835d6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "21667380c1fd74f7b166beb990228af8d6344ccfa33139c8abbc4601afbce857"
    sha256 cellar: :any_skip_relocation, ventura:       "f7759fa82b95fedd7b9007a4d78d7650bb6f3fb128d142245d73a240e8cbf017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "919b8b8f007bc8f801f81dbc4ccdd51fb8ab4c3570bbfffa2c7436ac5409e4a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6eef40b7f6a26e0013ddb66b430bb2bb2c252f568aca126398b31e0e32467e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "samply")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/samply --version")

    test_perf_json = testpath/"test_perf.json"
    test_perf_json.write ""

    output = shell_output("#{bin}/samply import --no-open #{test_perf_json} 2>&1", 1)
    assert_match "Error importing perf.data file", output
  end
end
