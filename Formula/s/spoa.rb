class Spoa < Formula
  desc "SIMD partial order alignment tool/library"
  homepage "https://github.com/rvaser/spoa"
  url "https://github.com/rvaser/spoa/archive/refs/tags/4.1.6.tar.gz"
  sha256 "5c69a2329456f9d7f611eccddf5cc8e85414a2f2ad23b539f77140919ba0da27"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "917e9fadb2ca216ba79721022a4982e3e4074efe0cc1c4891595c9ba9a67fa60"
    sha256 cellar: :any, arm64_tahoe:       "00eb584be69d6f80170e8cafe0edd4e6f2ebe86d297b961ae7979bb11b04bb57"
    sha256 cellar: :any, arm64_sequoia:     "1068ae766eb60ed5755359cdcdaeab543574b607d0bdacc86e875122e2316a33"
    sha256 cellar: :any, arm64_linux:       "25477b09120a0eb8037fdeee8f2473ef26bfa8bae9178bdf5deb67f3af29ca19"
    sha256 cellar: :any, x86_64_linux:      "8cc7f361f9ba41108707430405ec6247769c9092fc644ba23671a0c41090a079"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "bioparser" do
    url "https://github.com/rvaser/bioparser/archive/refs/tags/3.1.0.tar.gz"
    sha256 "ddb48cb456c72cf2955adf056c9204caf65483ec0a5bbba47389bc30ed9fdd05"
  end

  resource "biosoup" do
    url "https://github.com/rvaser/biosoup/archive/refs/tags/0.11.0.tar.gz"
    sha256 "e4addc3965ca9291535a131c07ef958a98e779ef1375d38d354536df66e16cd4"
  end

  deny_network_access!

  def install
    resources.each do |r|
      ENV.append_path "CMAKE_PREFIX_PATH", buildpath/"stage"
      r.stage do
        system "cmake", "-S", ".", "-B", "build",
                        "-D#{r.name}_build_tests=OFF",
                        *std_cmake_args(install_prefix: buildpath/"stage")
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
    end

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -Dspoa_build_tests=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spoa --version")

    output = shell_output("#{bin}/spoa #{pkgshare}/data/sample.fastq.gz")
    assert_match ">Consensus", output
  end
end
