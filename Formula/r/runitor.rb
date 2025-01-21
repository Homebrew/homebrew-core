class Runitor < Formula
  desc "Command runner with healthchecks.io integration"
  homepage "https://github.com/bdd/runitor"
  url "https://github.com/bdd/runitor/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "d654d4fb55b2adee445d2160ec937529f9a052220554a46874a8a5c64c52be06"
  license "0BSD"
  head "https://github.com/bdd/runitor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "862b3af6b1b84bd87aad4f08290a459ab3bd59d59a2f9fd4730da8b1e3d63060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "862b3af6b1b84bd87aad4f08290a459ab3bd59d59a2f9fd4730da8b1e3d63060"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "862b3af6b1b84bd87aad4f08290a459ab3bd59d59a2f9fd4730da8b1e3d63060"
    sha256 cellar: :any_skip_relocation, sonoma:        "98bfedbbce4c27d2fe8166696b4d077b0f2419f23aa34218252db328d874e84b"
    sha256 cellar: :any_skip_relocation, ventura:       "98bfedbbce4c27d2fe8166696b4d077b0f2419f23aa34218252db328d874e84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b21a8bf5896b78e2347f111c7922b092685ee4f18c1d91d189059863cf9fe49"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/runitor"
  end

  test do
    output = shell_output("#{bin}/runitor -uuid 00000000-0000-0000-0000-000000000000 true 2>&1")
    assert_match "error response: 400 Bad Request", output
    assert_equal "runitor #{version}", shell_output("#{bin}/runitor -version").strip
  end
end
