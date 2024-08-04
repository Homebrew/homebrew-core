class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "9637469ed0d92cca64f47a0c1f5730b4346bbf4b954f017c40c4a94be1b8fdf5"
  license "Apache-2.0"
  head "https://github.com/refaktor/rye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75cf7a35727d625f3cb3de56db2f106dac008122292b578e19fe8af265b5a44a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b76f6c00d925326591011b07b25b7d920e0f28a69064b7350703252895dbc88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83c59e7ff151facc9075ca5ae8dc5092b4ca62aeaa1f7647c768c8d6fce698a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba4cb347ed25b36981a2a8f690a9cf2fe7c17c2cf137e19d1836a5f7f3ebf3fe"
    sha256 cellar: :any_skip_relocation, ventura:        "e4e6058f390392f4d0a967be78949f549a6fe97337b7f65c9034cdf55b182310"
    sha256 cellar: :any_skip_relocation, monterey:       "0e7d74ae354f57ec28564eac98555307c97332b0eb72ef8b33e9859d44f4ba60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56d80480ca0b955b0f8fe3138edcdfba72ac884130408c9837ddd09835ac454f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath/"hello.rye", :exist?
    output = shell_output("#{bin}/ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
