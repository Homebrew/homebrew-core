class Scriptisto < Formula
  desc "Language-agnostic \"shebang interpreter\" to write scripts in compiled languages"
  homepage "https://github.com/igor-petruk/scriptisto"
  url "https://github.com/igor-petruk/scriptisto/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "192d20885b563eeaf66766695314ab3e2711dc10c44f938aeeee6271e9720397"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d2bf35c77bc8003d0139ced824741d362edf5d789af0ae162228fcd95c33b478"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b817e471743b6cc577956edf5f23e94c9f3187e7acd2836c1536d61555bb70ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "962438fd18d9f434b593e0b4f3e5ae907993a6538c225f8a7c92adae3ded797c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02658b3baaeb3fba08067cb154742902c83e0cc5365428fecea581d59075f9b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "019c58e7262b36e0c58dfe2b691c240ed95a61fbf1e632628794856b28262f3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c586e045919918edbd2db012047eb30954a21c7f7c1758e0d1c1aeb90aca9a2"
    sha256 cellar: :any_skip_relocation, ventura:        "7cc46782245c45d92f7729c387d01fb8aafab7412db46841cbc050f6f8868402"
    sha256 cellar: :any_skip_relocation, monterey:       "71f480bb22ef0b004d8659d50226118ef2236178d9e4a884777a2b76bcfc40d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6fa6858d7267ea5b8447b5a841dea92c4a3951fdc62d5e347ccff232b1893e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeb6d0436c7092c1056e3e1baca883a891a3dfb700517d28b6f07e4665151f3a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"hello-c.c").write <<~C
      #!/usr/bin/env scriptisto

      // scriptisto-begin
      // script_src: main.c
      // build_cmd: cc -O2 main.c -o ./script
      // scriptisto-end

      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    C
    assert_equal "Hello, world!\n", shell_output("#{bin}/scriptisto ./hello-c.c")
  end
end
