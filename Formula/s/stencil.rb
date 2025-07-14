class Stencil < Formula
  desc "Modern living-template engine for evolving repositories"
  homepage "https://stencil.rgst.io"
  url "https://github.com/rgst-io/stencil/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "3616617da31a47d23aa736a1d82335194d5fd29220902d7d66eb2a6c4ef8be31"
  license "Apache-2.0"
  head "https://github.com/rgst-io/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c885141c82810239115ff17101199a65d732dad9c5c6909be6c86e7a6224bae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9eb16a46076237220ca89b1f1a6b161083fe2c6225bc759fa3f9f3da8818408"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c16e8e831ec04ce1bbcedbe30bca9672b256c4edf372fa7e956058e82cb54f9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6548558f60db9d045d6bad3dee88371ee64d995c49fbfbba7bae20b91d1de0e1"
    sha256 cellar: :any_skip_relocation, ventura:       "ba40518b1479d3672f03780901d2dd0c9424b70a805fc5ed25f59a70e0ff5ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "401f1ef9243da882be600868656ec79e7399e4bb194272381adba202eec287c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4291fcde7e54f94d5ffbce96a5a5db36ec727f5c3d2a4460928ff3aa97fae90"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.rgst.io/stencil/v2/internal/version.version=#{version}
      -X go.rgst.io/stencil/v2/internal/version.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_path_exists testpath/"stencil.lock"
  end
end
