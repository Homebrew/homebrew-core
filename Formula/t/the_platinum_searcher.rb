class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "3d5412208644b13723b2b7ca4af0870d25c654e3a76feee846164c51b88240b0"
  license "MIT"
  head "https://github.com/monochromegane/the_platinum_searcher.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "83e283a230eb2226c0664d30e2bfceebf1e5cf42dbf4841bbdafc96cffd6307e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2ba93995429038b3bc692cf512396e683d766b131a307e63afbbe913218b54c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a410fe6377573632c20334478aa337d0c4c39660402881d31d356b6ce055e05d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d34acea6e7a4f0bfff85c75756c119ad978a11e72e2901f15e40a107cd1a8564"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "920eca3416a24f405f47f9422797e405768da23008de8ec12f3beb292e8b6be2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f3097b2d88f4b8479ecb3e3439f6688656fc1c5e20f18a4c300edf9ea953874"
    sha256 cellar: :any_skip_relocation, sonoma:         "8651447550ab494a2cd70ebd3339f3d3d705606b2683f12dcb9722de69ff2d55"
    sha256 cellar: :any_skip_relocation, ventura:        "f2f494e7c9a055b112241f2a9d30b260f6aec006382337941c7bb6ea23c5ef74"
    sha256 cellar: :any_skip_relocation, monterey:       "b9f8d4628e265fe8cee61b17d40a0695316940d4805d84ee98de11abc6dc54fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "63cc973af4c1fc612acb86c7a928f1680f84db7edfae52f374b95925c00761dc"
    sha256 cellar: :any_skip_relocation, catalina:       "79066cac44fd6cd21b8feadc9737045f98846832f15bd2a2e1fdaae3a8165e6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c21d15d5a6ac396326e399a183e29cac1ac75f71215f8052eba4acc021b0ab3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ba21397a0538c990656c24ba157c5650ea62a26da823afdba238da37226d3b"
  end

  depends_on "go" => :build

  conflicts_with "tcl-tk", because: "both install `pt` binaries"

  # Patch to remove godep dependency. Remove when this is merged into release:
  # https://github.com/monochromegane/the_platinum_searcher/pull/211
  patch do
    url "https://github.com/monochromegane/the_platinum_searcher/commit/763f368fe26fa44a12e1a37598185322aa30ba8f.patch?full_index=1"
    sha256 "2ee0f53065663f22f3c44b30c5804e37b8cb49200a30c4513b9ef668441dd543"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"pt"), "./cmd/pt"
  end

  test do
    path = testpath/"hello_world.txt"
    path.write "Hello World!"

    lines = shell_output("#{bin}/pt 'Hello World!' #{path}").strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
