class V8AT315 < Formula
  desc "Google's open source JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://github.com/v8/v8/archive/refs/tags/3.15.11.18.tar.gz"
  sha256 "93a4945a550e5718d474113d9769a3c010ba21e3764df8f22932903cd106314d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, monterey:    "e8a4181b1af77730c7345d61cf38b2a0cb19135e2963d2bddf9bbcc07357e503"
    sha256 cellar: :any, big_sur:     "8d1b84feddb4827106ad10d573f41fc6f4c1ddf6cbc65d78d8e168d7ab541e07"
    sha256 cellar: :any, catalina:    "588e9a3b61c54705d918bc783e1aa2efa1fd31626ca20181c7fe3c38d0d50ca5"
    sha256 cellar: :any, mojave:      "38ef56c652ac4f91ec1ddac61b8719ffba4c949103a6636e15aa1cd768e2d14d"
    sha256 cellar: :any, high_sierra: "42c0c3b3f4dc7153023e14aef59c623f10c78ffe8f2d7a43ab984f2810a694dd"
    sha256 cellar: :any, sierra:      "4b845ce6a7fdc4110518dfbf48ab721d7f48b9e64f78e6d1cc199078ac9d874b"
    sha256 cellar: :any, el_capitan:  "9c191175be793dba50999f5ac1894f26b9eb39ca231f0618d5954833e5db8945"
  end

  keg_only :versioned_formula

  disable! date: "2023-06-19", because: "depends on Python 2 to build"

  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        revision: "f7bc250ccc4d619a1cf238db87e5979f89ff36d7"
  end

  def install
    # Bully GYP into correctly linking with c++11
    ENV.cxx11
    ENV["GYP_DEFINES"] = "clang=1 mac_deployment_target=#{MacOS.version}" if OS.mac?

    (buildpath/"build/gyp").install resource("gyp")

    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    system "make", "native",
                   "-j#{ENV.make_jobs}",
                   "library=shared",
                   "snapshot=on",
                   "console=readline"

    prefix.install "include"
    cd "out/native" do
      lib.install Dir["lib*"]
      bin.install "d8", "lineprocessor", "mksnapshot", "preparser", "process", "shell" => "v8"
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end
