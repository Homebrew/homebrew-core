class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.18.tar.gz"
  sha256 "3f3407a78aca7fc3b42a3fc1f1d2b9724c1e4c71fbd5d37ff12976cd2305cec1"

  def install
    system "make"
  end

  test do
    # test version CLI command
    version_output = shell_output("#{bin}/v -v")
    assert_match version.to_s, version_output

    # test help CLI command
    help_output = shell_output("#{bin}/v -h")
    assert_match "Usage: v [options] [file | directory]", help_output
    assert_match "Options:", help_output
    assert_match "-                 Read from stdin (Default; Interactive mode if in a tty)", help_output
    assert_match "-h, help          Display this information.", help_output
    assert_match "-v, version       Display compiler version.", help_output
    assert_match "-prod             Build an optimized executable.", help_output
    assert_match "-o <file>         Place output into <file>.", help_output
    assert_match "-obf              Obfuscate the resulting binary.", help_output
    assert_match "-show_c_cmd       Print the full C compilation command and how much time it took.", help_output
    assert_match "-debug            Leave a C file for debugging in .program.c.", help_output
    assert_match "-live             Enable hot code reloading (required by functions marked with [live]).", help_output
    assert_match "fmt               Run vfmt to format the source code.", help_output
    assert_match "up                Update V.", help_output
    assert_match "run               Build and execute a V program. You can add arguments after the file name.", help_output
    assert_match "build module      Compile a module into an object file.", help_output

    # run tests and test output
    test_output = shell_output("#{bin}/v test v")
    assert_match "compiler/tests/enum_test.v OK", test_output
    assert_match "compiler/tests/msvc_test.v OK", test_output
    assert_match "compiler/tests/fn_test.v OK", test_output
    assert_match "compiler/tests/string_interpolation_test.v OK", test_output
    assert_match "compiler/tests/match_test.v OK", test_output
    assert_match "compiler/tests/option_test.v OK", test_output
    assert_match "compiler/tests/repl/repl_test.v OK", test_output
    assert_match "compiler/tests/mut_test.v OK", test_output
    assert_match "compiler/tests/str_gen_test.v OK", test_output
    assert_match "compiler/tests/interface_test.v OK", test_output
    assert_match "compiler/tests/defer_test.v OK", test_output
    assert_match "compiler/tests/module_test.v OK", test_output
    assert_match "compiler/tests/local_test.v OK", test_output
    assert_match "compiler/tests/struct_test.v OK", test_output
    assert_match "vlib/crypto/sha512/sha512_test.v OK", test_output
    assert_match "vlib/crypto/md5/md5_test.v OK", test_output
    assert_match "vlib/crypto/rc4/rc4_test.v OK", test_output
    assert_match "vlib/crypto/sha256/sha256_test.v OK", test_output
    assert_match "vlib/crypto/sha1/sha1_test.v OK", test_output
    assert_match "vlib/crypto/rand/rand_test.v OK", test_output
    assert_match "vlib/crypto/aes/aes_test.v OK", test_output
    assert_match "vlib/flag/flag_test.v OK", test_output
    assert_match "vlib/strings/strings_test.v OK", test_output
    assert_match "vlib/strings/builder_test.v OK", test_output
    assert_match "vlib/net/urllib/urllib_test.v OK", test_output
    assert_match "vlib/net/socket_udp_test.v OK", test_output
    assert_match "vlib/net/socket_test.v OK", test_output
    assert_match "vlib/hash/crc32/crc32_test.v OK", test_output
    assert_match "vlib/encoding/base64/base64_test.v OK", test_output
    assert_match "vlib/encoding/csv/csv_test.v OK", test_output
    assert_match "vlib/math/complex/complex_test.v OK", test_output
    assert_match "vlib/math/fractions/fraction_test.v OK", test_output
    assert_match "vlib/math/stats/stats_test.v OK", test_output
    assert_match "vlib/math/math_test.v OK", test_output
    assert_match "vlib/time/time_test.v OK", test_output
    assert_match "vlib/bitfield/bitfield_test.v OK", test_output
    assert_match "vlib/json/json_test.v OK", test_output
    assert_match "vlib/http/http_test.v OK", test_output
    assert_match "vlib/os/os_test.v OK", test_output
    assert_match "vlib/orm/orm_test.v OK", test_output
    assert_match "vlib/rand/rand_test.v OK", test_output
    assert_match "vlib/glm/glm_test.v OK", test_output
    assert_match "vlib/builtin/int_test.v OK", test_output
    assert_match "vlib/builtin/map_test.v OK", test_output
    assert_match "vlib/builtin/string_test.v OK", test_output
    assert_match "vlib/builtin/array_test.v OK", test_output
    assert_match "vlib/builtin/utf8_test.v OK", test_output
    assert_match "vlib/builtin/byte_test.v OK", test_output

    assert_match "Building examples...", test_output
    assert_match "examples/vweb/test_app.v OK", test_output
    assert_match "examples/json.v OK", test_output
    assert_match "examples/log.v OK", test_output
    assert_match "examples/database/mysql.v OK", test_output
    assert_match "examples/database/pg/customer.v OK", test_output
    assert_match "examples/vcasino/VCasino.v OK", test_output
    assert_match "examples/news_fetcher.v OK", test_output
    assert_match "examples/spectral.v OK", test_output
    assert_match "examples/tetris/tetris.v OK", test_output
    assert_match "examples/hot_reload/bounce.v OK", test_output
    assert_match "examples/hot_reload/graph.v OK", test_output
    assert_match "examples/hot_reload/message.v OK", test_output
    assert_match "examples/hello_world.v OK", test_output
    assert_match "examples/word_counter/word_counter.v OK", test_output
    assert_match "examples/terminal_control.v OK", test_output
    assert_match "examples/game_of_life/life.v OK", test_output
    assert_match "examples/links_scraper.v OK", test_output
    assert_match "examples/nbody.v OK", test_output
    assert_match "examples/rune.v OK", test_output
  end
end
