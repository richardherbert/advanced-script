<cfoutput><div >
	<div>
		<h1>Forgotten Password</h1>

		#getInstance( 'messagebox@cbmessagebox' ).renderIt()#

		<form action="#event.buildLink( 'signin.forgottenpasswordaction' )#" method="POST">
			<div >
				<label for="emailAddress">Email address</label>

				<input id="emailAddress" name="emailAddress" type="email" aria-describedby="emailHelp" autofocus required>

				<small id="emailHelp">We'll send you instructions</small>
			</div>

			<button type="submit">Reset password</button>
		</form>
	</div>
</div></cfoutput>
