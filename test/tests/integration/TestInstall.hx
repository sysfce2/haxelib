package tests.integration;

class TestInstall extends IntegrationTests {

	override function setup(){
		super.setup();

		final r = haxelib(["register", bar.user, bar.email, bar.fullname, bar.pw, bar.pw]).result();
		assertSuccess(r);
		final r = haxelib(["submit", Path.join([IntegrationTests.projectRoot, "test/libraries/libBar.zip"]), bar.pw]).result();
		assertSuccess(r);

		final r = haxelib(["register", foo.user, foo.email, foo.fullname, foo.pw, foo.pw]).result();
		assertSuccess(r);
		final r = haxelib(["submit", Path.join([IntegrationTests.projectRoot, "test/libraries/libFoo.zip"]), foo.pw]).result();
		assertSuccess(r);
	}

	function testNormal():Void {
		{
			final r = haxelib(["install", "Bar"]).result();
			assertSuccess(r);
		}

		{
			final r = haxelib(["list", "Bar"]).result();
			assertTrue(r.out.indexOf("Bar") >= 0);
			assertSuccess(r);
		}

	}

	// for issue #529
	function testDifferentCapitalization() {
		{
			final r = haxelib(["install", "bar"]).result();
			assertSuccess(r);
		}

		{
			final r = haxelib(["list", "Bar"]).result();
			assertTrue(r.out.indexOf("Bar") >= 0);
			assertSuccess(r);
		}

		{
			final r = haxelib(["install", "bar"]).result();
			assertEquals("Bar version 1.0.0 is already installed and set as current.", r.out.trim());
			// recognises that we already have the newest version
		}

		{
			final r = haxelib(["install", "Bar"]).result();
			assertEquals("Bar version 1.0.0 is already installed and set as current.", r.out.trim());
			// recognises that we already have the newest version
		}
	}

	function testFromHaxelibJson() {
		final haxelibJson = Path.join([IntegrationTests.projectRoot, "test/libraries/libFoo/haxelib.json"]);

		{
			final r = haxelib(["install", haxelibJson]).result();
			assertSuccess(r);
		}

		{
			final r = haxelib(["list", "Bar"]).result();
			assertTrue(r.out.indexOf("Bar") >= 0);
			assertSuccess(r);
		}
	}
	// for issue #529
	function testFromHaxelibJson_DifferentCapitalization() {
		final haxelibJson = Path.join([IntegrationTests.projectRoot, "test/libraries/libFoo/other_haxelib.json"]);

		{
			final r = haxelib(["install", haxelibJson]).result();
			assertSuccess(r);
		}

		{
			final r = haxelib(["list", "Bar"]).result();
			assertTrue(r.out.indexOf("Bar") >= 0);
			assertSuccess(r);
		}
	}

	function testFromHaxelibJsonWithSkipDependencies() {
		final haxelibJson = Path.join([IntegrationTests.projectRoot, "test/libraries/libFoo/other_foo_haxelib.json"]);

		{
			final r = haxelib(["install", haxelibJson, "--skip-dependencies"]).result();
			assertSuccess(r);
		}

		{
			final r = haxelib(["list"]).result();
			assertSuccess(r);
			// Foo was still installed
			assertTrue(r.out.indexOf("Foo") >= 0);
			// but bar wasn't
			assertTrue(r.out.indexOf("Bar") < 0);
		}
	}

	function testFromHxml() {
		final hxml = Path.join([IntegrationTests.projectRoot, "test/libraries/libFoo/build.hxml"]);

		{
			final r = haxelib(["install", hxml, "--always"]).result();
			assertSuccess(r);
		}

		{
			final r = haxelib(["list", "Bar"]).result();
			assertTrue(r.out.indexOf("Bar") >= 0);
			assertSuccess(r);
		}
	}

	// for issue #529 and #503
	function testFromHxml_DifferentCapitalization() {
		final hxml = Path.join([IntegrationTests.projectRoot, "test/libraries/libFoo/other_build.hxml"]);

		{
			final r = haxelib(["install", hxml, "--always"]).result();
			assertSuccess(r);
		}

		{
			final r = haxelib(["list", "Bar"]).result();
			assertTrue(r.out.indexOf("Bar") >= 0);
			assertSuccess(r);
		}
	}
}