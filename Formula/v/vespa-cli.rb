class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.230.17.tar.gz"
  sha256 "6af2fc0b71156af25b6d6455e22a6437afe8f8280a2634be55a041b32126638e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d33aa47b4817ddf5abf9a77dbb47cfbf40d050caf2dc30a9c8ef94b6c6e8630"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43f7177fc1a30df2ee5be64d41322b583a5b79c4ee40add900b3e899e907b16f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d05cf71df9d71fdd6f43767f509a12efd45e5aacdb14ebd25d3e9093eedf9a81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1d46ba69efb79066a774bbe06a1c8d1178f70fa469cb01cc249a0eeb930f9b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a16fe8ff4f3c65e45f883c4b8305d6f1e21ffa396fee42b0944e22c97e9da5d"
    sha256 cellar: :any_skip_relocation, ventura:        "893a6c65a90cfb2248b8ad8b406c367158caab0e0b391da5b5657372ad4f2f7b"
    sha256 cellar: :any_skip_relocation, monterey:       "66e4feb0b6cf5a83894e3d152df4658aed6029d8c7d652e9f431b68d91ec4aca"
    sha256 cellar: :any_skip_relocation, big_sur:        "766c77f27a4caea1e7ae894010d7bf0171854ba7aa6965504d635bd193a6c56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5674194ec62e142dcd68c87256b125ee61e1b7dd0b48db82e61272f7b18bcc5"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
