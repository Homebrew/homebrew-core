class Qp < Formula
  desc "Command-line (ND)JSON querying"
  homepage "https://github.com/f5io/qp"
  url "https://github.com/f5io/qp/archive/1.0.1.tar.gz"
  sha256 "6ef12fd4494262899ee12cc1ac0361ec0dd7b67e29c6ac6899d1df21efc7642b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "458188f1637fb0dc6f865c73b9dfb5e6146070ad0193507df7979236afc60294"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c583d1f819ffba8adcc8139efe3366ad4570f3efc7c94fb25742e4da602202e"
    sha256 cellar: :any_skip_relocation, monterey:       "ff9da9b5b7578cb0a87aeb8dff3aeaec5521952dc0764d1623f7e4241e0e1044"
    sha256 cellar: :any_skip_relocation, big_sur:        "83085c1f8cbeaf59a69f00f779a878ceb78b7aeaaf16278010d5d968c9d94742"
    sha256 cellar: :any_skip_relocation, catalina:       "a65499deed12110ed5a21f3bbd657acdaaf1452dea48877caac93bda55759370"
    sha256 cellar: :any_skip_relocation, mojave:         "f119afd6bacbac5af055c398a2dfb5c4f62c8f113bcb9e12dab825800fd8e744"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d9c595a53f82ddd9f086fac02a5f8da34e65d9b0e7564fce02148304704457ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9a688fd124da927fb627c02b2a043c34d48727785a5be844dd1853a65ba8814"
  end

  depends_on "quickjs" => :build

  resource "csp-js" do
    url "https://unpkg.com/@paybase/csp@1.0.8/dist/esm/index.js"
    sha256 "d50e6a6d5111a27a5b50c2b173d805a8f680b7ac996aa1c543e7b855ade4681c"
  end

  def install
    mkdir bin.to_s

    resource("csp-js").stage { cp_r "index.js", buildpath/"src/csp.js" }

    system "qjsc",  "-o", "#{bin}/qp",
                          "-fno-proxy",
                          "-fno-eval",
                          "-fno-string-normalize",
                          "-fno-map",
                          "-fno-typedarray",
                          "src/main.js"
  end

  test do
    assert_equal "{\"id\":1}\n", pipe_output("#{bin}/qp 'select id'", "{\"id\": 1, \"name\": \"test\"}")
  end
end
