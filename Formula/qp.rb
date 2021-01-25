class Qp < Formula
  desc "Command-line (ND)JSON querying"
  homepage "https://github.com/paybase/qp"
  url "https://github.com/paybase/qp/archive/1.0.1.tar.gz"
  sha256 "6ef12fd4494262899ee12cc1ac0361ec0dd7b67e29c6ac6899d1df21efc7642b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "83085c1f8cbeaf59a69f00f779a878ceb78b7aeaaf16278010d5d968c9d94742" => :big_sur
    sha256 "2c583d1f819ffba8adcc8139efe3366ad4570f3efc7c94fb25742e4da602202e" => :arm64_big_sur
    sha256 "a65499deed12110ed5a21f3bbd657acdaaf1452dea48877caac93bda55759370" => :catalina
    sha256 "f119afd6bacbac5af055c398a2dfb5c4f62c8f113bcb9e12dab825800fd8e744" => :mojave
    sha256 "d9c595a53f82ddd9f086fac02a5f8da34e65d9b0e7564fce02148304704457ed" => :high_sierra
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
