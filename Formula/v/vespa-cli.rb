class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.243.29.tar.gz"
  sha256 "fb7538719c035be57e50c3a58b406444f775cf73e21acc3e3d4c7349c4292da1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f03c8dc0d36715d73dc5c0ca2918badabc9bad71588ce82c18819d4a261d5553"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e185bc821237f917f6265db4b2bed918ac1677c7da2ce74ab323850e1edbd63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f19cc8470cd746e12f6ff041ac23fe408113f667dab4f261171aaf8e2587c4eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "3951e9312d0ea0ca67b938e713cd5496311bbffb6bf86ad71a4c44b1cde891d4"
    sha256 cellar: :any_skip_relocation, ventura:        "66ee4d881efa44c9335820b49a81f8b3f659b13e6075e04fbc8778d0fb1f289e"
    sha256 cellar: :any_skip_relocation, monterey:       "74650f76c3e40e7dbf754dc7fded9874ec2327cc050db523479f444fe28bd005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db77ac14b46e279a270beab14337fb771579fca834692ba1646eb1f659b13bb8"
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
