class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "af63d78360e3a25931d901ed638cf663b26e49c5d1ad575f0d87fc8d8c497719"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17b140c77d7734ad1e2069701c65cf6fbcd269177fd34a48c4aed5d2007a96f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f32126d675201b096741d6905cf11782e1d1dbc5c2a1bd92a83fca98d866753c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a104f49815de11ecfedd5238f1933f65935016673b9afe301083a7563768c7ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ec629a94c0f8bdb1f86a99d4fa4b502f88448a12dbc691ea9ba51ab063b157a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3df4b435fa079594fbbf2910ee092f174b71da5828a76e8b2b3825729b45c272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf09532e3fa92fae02e303b55e4d27ab580b55e438120074e6faeaad2d3e889"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
