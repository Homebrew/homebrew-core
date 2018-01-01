# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://github.com/v8/v8-git-mirror/archive/5.1.281.47.tar.gz"
  sha256 "63c9933227d6912689ea6bc012eea6a1fabaf526ac04bc245d9381e3ea238bf6"

  bottle do
    cellar :any
    sha256 "179a8442510eb0a022ea6823cd6a76044c14c4fe18415710cac3d746d432020e" => :high_sierra
    sha256 "8106efc14371982af11a66d8db533dc0589bc240950e0e445467cf6ce8871393" => :sierra
    sha256 "487f2ca72096ee27d13533a6dad2d472a92ba40ef518a45226f19e94d4a79242" => :el_capitan
    sha256 "dc9af3e08eda8a4acd1ff3c6b47a4c5170a92dbab7d2d79958a14d8aa42eefac" => :yosemite
    sha256 "7bcd1bbd66c11305eeea0c36ca472de8a639f511abe0909c8815b1208dbce7b6" => :mavericks
  end

  option "with-readline", "Use readline instead of libedit"

  # not building on Snow Leopard:
  # https://github.com/Homebrew/homebrew/issues/21426
  depends_on :macos => :lion

  # gyp doesn't run under 2.6 or lower
  depends_on "python" => :build if MacOS.version <= :snow_leopard

  depends_on "readline" => :optional

  needs :cxx11

  # Update from "DEPS" file in tarball.
  # Note that we don't require the "test" DEPS because we don't run the tests.
  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "4ec6c4e3a94bd04a6da2858163d40b2429b8aad1"
  end

  resource "icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
        :revision => "c291cde264469b20ca969ce8832088acb21e0c48"
  end

  resource "buildtools" do
    url "https://chromium.googlesource.com/chromium/buildtools.git",
        :revision => "80b5126f91be4eb359248d28696746ef09d5be67"
  end

  resource "common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
        :revision => "c8c8665c2deaf1cc749d9f8e153256d4f67bf1b8"
  end

  resource "swarming_client" do
    url "https://chromium.googlesource.com/external/swarming.client.git",
        :revision => "df6e95e7669883c8fe9ef956c69a544154701a49"
  end

  resource "gtest" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
        :revision => "6f8a66431cb592dad629028a50b3dd418a408c87"
  end

  resource "gmock" do
    url "https://chromium.googlesource.com/external/googlemock.git",
        :revision => "0421b6f358139f02e102c9c332ce19a33faf75be"
  end

  resource "clang" do
    url "https://chromium.googlesource.com/chromium/src/tools/clang.git",
        :revision => "faee82e064e04e5cbf60cc7327e7a81d2a4557ad"
  end

  def install
    # Bully GYP into correctly linking with c++11
    ENV.cxx11
    ENV["GYP_DEFINES"] = "clang=1 mac_deployment_target=#{MacOS.version}"
    # https://code.google.com/p/v8/issues/detail?id=4511#c3
    ENV.append "GYP_DEFINES", "v8_use_external_startup_data=0"

    # fix up libv8.dylib install_name
    # https://github.com/Homebrew/homebrew/issues/36571
    # https://code.google.com/p/v8/issues/detail?id=3871
    inreplace "tools/gyp/v8.gyp",
              "'OTHER_LDFLAGS': ['-dynamiclib', '-all_load']",
              "\\0, 'DYLIB_INSTALL_NAME_BASE': '#{opt_lib}'"

    (buildpath/"build/gyp").install resource("gyp")
    (buildpath/"third_party/icu").install resource("icu")
    (buildpath/"buildtools").install resource("buildtools")
    (buildpath/"base/trace_event/common").install resource("common")
    (buildpath/"tools/swarming_client").install resource("swarming_client")
    (buildpath/"testing/gtest").install resource("gtest")
    (buildpath/"testing/gmock").install resource("gmock")
    (buildpath/"tools/clang").install resource("clang")

    system "make", "native", "library=shared", "snapshot=on",
                   "console=readline", "i18nsupport=off",
                   "strictaliasing=off"

    include.install Dir["include/*"]

    cd "out/native" do
      rm ["libgmock.a", "libgtest.a"]
      lib.install Dir["lib*"]
      bin.install "d8", "mksnapshot", "process", "shell" => "v8"
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/v8 -e 'print(\"Hello World!\")'").chomp
  end
end
