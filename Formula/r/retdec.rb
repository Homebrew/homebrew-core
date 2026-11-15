class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  license all_of: ["MIT", "Zlib"]
  revision 1
  head "https://github.com/avast/retdec.git", branch: "master"

  stable do
    url "https://github.com/avast/retdec.git",
        tag:      "v5.0",
        revision: "53e55b4b26e9b843787f0e06d867441e32b1604e"

    patch do
      url "https://github.com/avast/retdec/commit/79d65efd82f7ea9e8c68cf9e47351a60bc850b21.patch?full_index=1"
      sha256 "ccb90c4a4b893171c794d5dfb987aca5a4c726fabaeddc5f1af97f771ea243a1"
      type :backport
      resolves "https://github.com/avast/retdec/pull/1153"
    end

    # Backport updates for authenticode-parser
    patch do
      url "https://github.com/avast/retdec/commit/094a37393fd87e3562b4b755a94f5b41134d8bf3.patch?full_index=1"
      sha256 "ea491234d65e34539ce443e378a93f26c539f88eeeb6cdbdfdbf4218e4091469"
      type :backport
    end
    patch do
      url "https://github.com/avast/retdec/commit/2921f93f4530dd239a2e1dd7ab78d94d5ef51c8b.patch?full_index=1"
      sha256 "11e5c51c5749f0c71421e68ef7a45e184d3ca40ae5da562240ea5b8238898904"
      type :backport
    end
  end

  bottle do
    rebuild 6
    sha256 cellar: :any, arm64_golden_gate: "e2d2033c9881b746e559a0f55e9a0e329ce2f8fcd7bedbfb71227127a3718160"
    sha256 cellar: :any, arm64_tahoe:       "2400a33b1c689d213f33675c18155b99f601900aaadf372eb33bc8ba91b06188"
    sha256 cellar: :any, arm64_sequoia:     "5ef8b4f7b6e4bcfb059265b55f71c79005a09c9ea4cebb99c9acc4c09623bfbe"
    sha256 cellar: :any, arm64_linux:       "27824f581bf138fb89c444cc054e60e44dcc6e344df2e6aaa0c883d71e88f8ec"
    sha256 cellar: :any, x86_64_linux:      "21715e61dea52b44668c88810e87dc63f9ee339a54d13752cdaadbbbdb6b152f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build # needs python on PATH
  depends_on "openssl@4"

  uses_from_macos "python"

  on_sequoia do
    depends_on xcode: ["16.4", :build] # workaround for std::char_traits<unsigned int> (149025504)
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Apply yara's patch to fix build with OpenSSL 4
  patch :p5 do
    url "https://github.com/VirusTotal/yara/commit/0da50fe5e6a94ff609755ec2b20ed9edc5757896.patch?full_index=1"
    sha256 "4addee3cfa2adc1cd3a655ed27689e1d447306bb490ea4af806a87fd9b987f30"
    directory "deps/authenticode-parser/src"
    type :unofficial
    resolves "https://github.com/avast/authenticode-parser/issues/23"
  end

  def install
    # Workaround for CMake 4 compatibility with multiple vendored deps
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    system "cmake", "-S", ".", "-B", "build", "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Running phase: cleanup",
    shell_output("#{bin}/retdec-decompiler -o #{testpath}/a.c #{test_fixtures("mach/a.out")} 2>/dev/null")
  end
end
