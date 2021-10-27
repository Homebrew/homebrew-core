class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.5.tar.gz"
  sha256 "dcf8dbc8939699e2e82141cb86688b6cd09da8cae5e18232ef14085c2366290c"
  license "GPL-2.0"
  head "https://github.com/RazrFalcon/svgcleaner.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "526c99b79cb8de90e2d43a2723dedc23786f16a1e3992669d071d478cffb7e9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4e1232a8f5f904166c97f537df03596bf133ea9d68a1ab08df2f4b0dfbbdc1b"
    sha256 cellar: :any_skip_relocation, monterey:       "b0f023be007c4b8a5cb02b91de3369ac0cb49b4bfccc8917ed5ee81ee1f7ea76"
    sha256 cellar: :any_skip_relocation, big_sur:        "69290442826481651a7e314ec175f7fc980640c53e7908aa5fd6e9cbff03a1dc"
    sha256 cellar: :any_skip_relocation, catalina:       "43533727baf2ed09cdce9fe64357c1bc1f70fed57d70f37cfd824b664ab1266f"
    sha256 cellar: :any_skip_relocation, mojave:         "bf18c353316b7a46ed2cecad188a638e359ce77acdcf501f578e5f96149ed667"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7e6df86bb8f994b157ff6de9bb7f43605b813a6a476f6f2d3af4d3483c1b6483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faae5c691c1bbb241aa001e912458be50a1aaf6eea241591b6a34148d3d93228"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"in.svg").write <<~EOS
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <svg
         xmlns="http://www.w3.org/2000/svg"
         version="1.1"
         width="150"
         height="150">
        <rect
           width="90"
           height="90"
           x="30"
           y="30"
           style="fill:#0000ff;fill-opacity:0.75;stroke:#000000"/>
      </svg>
    EOS
    system bin/"svgcleaner", "in.svg", "out.svg"
  end
end
