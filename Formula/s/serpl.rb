class Serpl < Formula
  desc "Simple terminal UI for search and replace"
  homepage "https://github.com/yassinebridi/serpl"
  url "https://github.com/yassinebridi/serpl/archive/refs/tags/0.3.4.tar.gz"
  sha256 "d3765e273f54bf2e268f9696eef5e5459ffe46310af8ae48eb6ebe4c279deb62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17d66f0a6070402ad1ca996de2076bcaff6ef5f4c474bfab7fcc0952de0978d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7170f6c039d004e719e86934352f1fc0a30929749c853e71f8ad6db97689511f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a78316d3e051f3eaeeb2b26263c24135382dd8038222eb5ca14253e80fe96790"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a87b7d3d19d97b7aa33dd296a4ba5f0b98057c3b0f4ecf345d2495148f3dec7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "90dd2fc2f33f9ba2d8122097e8b9f891f084f9038a4a2e5e26bf65fbb1c62335"
    sha256 cellar: :any_skip_relocation, ventura:       "7128ef970ad0e5c428037dbeae24bf722dc57c19706ef05cb626d72bbdb619f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfc0a698cbce4d7894689a991e6f8e72645cf22ffb5e03a10444b721cd8b20ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823f676ecea17d9ff2f20448c5a42963fcdc7378e89a6eff3a250e161d17ddd0"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serpl --version")

    assert_match "a value is required for '--project-root <PATH>' but none was supplied",
      shell_output("#{bin}/serpl --project-root 2>&1", 2)
  end
end
