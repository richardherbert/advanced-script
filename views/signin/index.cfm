<cfoutput><div>
	<div>
		<h1>Sign in</h1>

		#prc.MessageManager.renderIt()#

		<form action="#event.buildLink( 'signin.action' )#" method="POST">
			<div>
				<label for="emailAddress">Username</label>

				<input id="emailAddress" name="emailAddress" type="email" aria-describedby="emailHelp" autofocus required>

				<small id="emailHelp">Your registered email address</small>
			</div>

			<div>
				<label for="password">Password</label>

				<input id="password" name="password" type="password" required>
			</div>

			<div>
				<a href="#event.buildLink( 'signin.forgottenpassword' )#">Forgotton password</a>
			</div>

			<button type="submit">Sign in</button>
		</form>
	</div>
</div></cfoutput>
