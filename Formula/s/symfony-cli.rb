class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.11.0.tar.gz"
  sha256 "29996a4f7f2032fe1e3b1d8df734843f84ee7e2ac9db10e1e690ffc37df88713"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6fa2019639aee82e0f242d54e9d3985c69c027a931018f7ee294d9fe5d758da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e5af6706031cf92b8caaf523ab1e76de0ea2889134046b97cf5595fca7a6286"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a11438c2930e139d16705ddaed7a9987e737a62b3ba4dfc1bc8403e23d6c4fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ee4ab7ee1692dcfd6f5c173820ab31d57a23af4d60bcebe83aa1481c6338835"
    sha256 cellar: :any_skip_relocation, ventura:       "546f4c2e45674008eb121eb7b42b041015f0914788bf9e3002185a31edaf55e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e18d41965637af7bc93b1ba06b7de11cca3a3e122d2579cbb672eef0d76f5807"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}", output: bin/"symfony")
  end

  test do
    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end
