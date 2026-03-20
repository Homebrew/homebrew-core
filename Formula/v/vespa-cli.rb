class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/refs/tags/v8.660.21.tar.gz"
  sha256 "c36bcc9b5832209808113a05e4e8589c53aa004d78e60f6efcf921c7fe7a0a83"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44f0a95af529d8101d3194b312ba20320ea0b35f32b33714e595433196bb0f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1047914f7cededa264bc3dd1f91e24f10796f2bda548fe473e7bb6c804a22886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0e7a97fa974ceeba3430879d90518be8dbe8a52fc2f75e3fe4a23a962785c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fddc618a126c2d6c00f18745bc56580b2c640081148dedb91a9b80dd40603a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a509ea553262928e8ba129f03d7314ef661d1c51d3817dace18f6313e6fc8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d2b4b98baf4e4747f70558e9375c5b94e604b2788b71abf75e0977961dc36b"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", shell_parameter_format: :cobra)
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin/"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
