class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "4fdc1538d15faad08ff0db7940be6022077594c68dce3e95b8cb47afb47008c4"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54efb4d7bd7a08fcfe7c4afdb767bdb2e4929a24e38490e75286134e7ded8ded"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "748aa0f4a49b09b7e6d4b1b1942a18e147f1c3eee6ac609a57ecf76631f51aec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d51f2bb5a0cd91c506addff309a8c6f8a2ef483dda8a8ea9ad976171c7f9468"
    sha256 cellar: :any_skip_relocation, sonoma:         "279b35571c365dc81aa41eb64f2031e92bc88b2b6c04a37f3878e21a774b21ad"
    sha256 cellar: :any_skip_relocation, ventura:        "0a7fb8cdb1f320e3633a5ce7ae58c8d357483db451958c76d2dbafe79833adcf"
    sha256 cellar: :any_skip_relocation, monterey:       "2baf3596714ce87cb7737fa01bde05be4a7bb28eba0139b0807e5f6ab4702119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef2d48b95a43473a359193e2a86c7c75268e07f1fdb8796e5f31f02c71bf911b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"s"

    generate_completions_from_executable(bin/"s", "--completion", base_name: "s")
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
